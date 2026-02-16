{ lib, ... }:

{
  wk = rec {
    mkSpec =
      keys: args:
      let
        len = builtins.length keys;
        forbiddenKeys = builtins.filter (k: lib.hasPrefix "__unkeyed-" k) (builtins.attrNames args);
      in
      if len == 0 || len > 2 then
        throw "mkSpec: 'keys' list must have length 1 or 2, but got ${toString len}"
      else if forbiddenKeys != [ ] then
        throw "mkSpec: 'args' contains forbidden keys: ${lib.concatStringsSep ", " forbiddenKeys}"
      else
        (lib.listToAttrs (
          lib.imap1 (i: v: {
            name = "__unkeyed-${toString i}";
            value = v;
          }) keys
        ))
        // args;

    mkSpecHidden =
      lhs:
      mkSpec [ lhs ] {
        mode = modes.full;
        hidden = true;
      };

    modes = {
      all' = [
        "n"
        "v"
        "x"
        "s"
        "i"
        "c"
        "o"
        "l"
      ];

      all = [
        "n"
        "v"
        "x"
        "s"
        "i"
        "c"
        "o"
        # "l"
      ];

      full = [
        "n"
        "v"
        "x"
        "s"
        "i"
        "c"
        "t"
      ];

      common = [
        "n"
        "v"
        "x"
        "s"
        "t"
      ];

      interact = [
        "n"
        "v"
        "x"
        "s"
      ];

      view = [
        "n"
      ];

      input = [
        "i"
        "c"
        "t"
      ];

      operator = [ "o" ];
    };
  };
}
