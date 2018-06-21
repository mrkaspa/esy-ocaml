open Lwt
open LTerm_style
open LTerm_text

let hello () =
  LTerm.printls (eval [B_fg(yellow); S"Hello,"; E_fg; S" "; B_fg(green); S"World!"; E_fg])
