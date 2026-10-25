# Workaround: mozc 2.30.5544.102 fails to build against Qt >= 6.12 because uic
# rejects the custom widget class name "::mozc::gui::DictionaryContentTableWidget"
# (leading "::"). Drop this overlay once nixpkgs ships a mozc release that
# includes the upstream fix google/mozc@29c082a64b57.
final: prev: {
  mozc = prev.mozc.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/gui/dictionary_tool/dictionary_tool.ui \
        --replace-fail '::mozc::gui::DictionaryContentTableWidget' 'mozc::gui::DictionaryContentTableWidget'
    '';
  });
}
