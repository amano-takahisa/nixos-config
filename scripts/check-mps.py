"""Run in an SSH session with a temporary PyTorch environment; see README.md."""

import os
import platform

# Do not let unsupported operators silently fall back to the CPU.
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "0"

import torch

if not os.environ.get("SSH_CONNECTION"):
    raise SystemExit("Run this check through SSH to verify remote GPU access.")
if platform.system() != "Darwin":
    raise SystemExit("This check requires macOS.")
if not torch.backends.mps.is_built():
    raise SystemExit("This PyTorch build does not include MPS support.")
if not torch.backends.mps.is_available():
    raise SystemExit("MPS is not available in this SSH session.")

x = torch.arange(16, dtype=torch.float32).reshape(4, 4).to("mps")
x.requires_grad_()
y = x @ x.T
y.sum().backward()
torch.mps.synchronize()

assert y.device.type == "mps"
assert x.grad is not None and x.grad.device.type == "mps"
cpu_x = x.detach().cpu().requires_grad_()
cpu_y = cpu_x @ cpu_x.T
cpu_y.sum().backward()
torch.testing.assert_close(y.cpu(), cpu_y)
torch.testing.assert_close(x.grad.cpu(), cpu_x.grad)
print(f"PASS: PyTorch {torch.__version__}, {platform.machine()}, device={y.device}")
print("SSH: MPS matrix multiplication and backward pass match CPU results.")
