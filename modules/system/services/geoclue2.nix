{ ... }:

{
  services.geoclue2 = {
    enable = true;
    appConfig."firefox" = {
      isAllowed = true;
      isSystem = false;
    };
  };
}
