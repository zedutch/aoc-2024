open Base
open Stdio

let read_lines file = In_channel.with_file file ~f:(fun in_channel -> In_channel.input_lines in_channel)

let split_line line = Str.split (Str.regexp "   ") line

let split_list lines =
    let firsts = List.map ~f:split_line lines
        |> List.filter_map ~f:(
            fun l ->
            try Some (Int.of_string (List.hd_exn l)) with
            | Failure _ -> None
        ) in
    let seconds = List.map ~f:split_line lines
        |> List.filter_map ~f:(
            fun l ->
            try Some (Int.of_string (List.nth_exn l 1)) with
            | Failure _ -> None
        ) in
    firsts, seconds

let frequencies numbers =
    List.fold numbers
        ~init:(Map.empty (module Int))
        ~f:(fun acc n ->
            Map.update acc n ~f:(function
                | None -> 1
                | Some c -> c + 1
            )
        )

let solve1 lines =
    let firsts, seconds = split_list lines in
    let sorted_firsts = List.sort firsts ~compare in
    let sorted_seconds = List.sort seconds ~compare in
    List.map2_exn sorted_firsts sorted_seconds ~f:(fun f s -> (abs (f-s)))
    |> List.sum (module Int) ~f:Fn.id

let solve2 lines =
    let firsts, seconds = split_list lines in
    let freq_map = frequencies seconds in
    List.map firsts ~f:(fun n -> match Map.find freq_map n with
        | Some v -> n * v
        | None -> 0
    )
    |> List.sum (module Int) ~f:Fn.id

let solve part =
    let lines = read_lines "lib/day1.in" in
    let result = match part with
        | 1 -> solve1 lines
        | 2 -> solve2 lines
        | _ -> 0
    in
    Stdio.printf "Result: %d\n" result
