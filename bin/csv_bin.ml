(* Read from taf file and extracts content *)
open Core
open Lib.Util

let headers =
  [ "nombre"
  ; "min_peso"
  ; "max_peso"
  ; "kg_adicional"
  ; "precio_normal"
  ; "precio_mismo_dia"
  ; "tipo_vehiculo"
  ; "hub"
  ; "region_origen"
  ; "region_destino"
  ; "zona"
  ; "tipo" ]

let get_key key map =
  match String.Map.find map key with Some res -> res | None -> ""

let getFromMap map =
  ( get_key "zona" map
  , get_key "hub" map
  , get_key "precio_normal" map |> int_of_string )

let csv_transform_rev = getFromMap << String.Map.of_alist_exn << Csv.Row.to_assoc

let csv_transform = Csv.Row.to_assoc >> String.Map.of_alist_exn >> getFromMap

let read_file path =
  let csv = Csv.Rows.load ~has_header:true ~header:headers path in
  List.map ~f:csv_transform csv

let get_path () = match Sys.argv with [|_; path|] -> Some path | _ -> None

let () =
  get_path ()
  |> Option.bind ~f:(fun path ->
      print_string $ "Reading file " ^ path ^ "\n" ;
      Some (read_file path) )
  |> Option.bind ~f:(fun csv ->
      printf "Result---CSV---------------------------------\n" ;
      List.iter
        ~f:(fun (zona, hub, price) ->
            print_string $ zona ^ "," ^ hub ^ "," ^ string_of_int price ^ "\n"
          )
        csv
      |> Option.some )
  |> ignore
