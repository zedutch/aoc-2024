open Base
open Stdio

let read_lines file = In_channel.with_file file ~f:(fun in_channel -> In_channel.input_lines in_channel)

let split_line line =
    String.split line ~on:' '
    |> List.map ~f:Int.of_string

let rec check_line_asc list prev =
    match list with
    | hd1:: tl -> (
        if hd1 <= prev then
            false
        else if (abs (hd1 - prev)) < 4 then
            check_line_asc tl hd1
        else
            false
    )
    | _ -> true

let rec check_line_desc list prev  =
    match list with
    | hd1:: tl -> (
        if hd1 >= prev then
            false
        else if (abs (hd1 - prev)) < 4 then
            check_line_desc tl hd1
        else
            false
        )
    | _ -> true


let check_line = function
    | hd1 :: hd2 :: tl ->
        if hd1 > hd2 then
            check_line_desc (hd2::tl) hd1
        else
            check_line_asc (hd2::tl) hd1
    | _ -> true

let rec remove_at_index list index =
    match list, index with
    | [], _ -> []
    | _::tl, 0 -> tl
    | hd::tl, n -> hd :: remove_at_index tl (n-1)

let check_line_variants line =
    (* I have already solved this "properly" in Elixir today so I'm just brute-forcing the OCaml solution *)
    match check_line line with
    | true -> true
    | false -> (
        List.range 0 (List.length line)
        |> List.map ~f:(fun i -> remove_at_index line i)
        |> List.map ~f:check_line
        |> List.exists ~f:Fn.id
    )

let split_list lines =
    lines
    |> List.map ~f:split_line
    |> List.map ~f:check_line
    |> List.count ~f:Fn.id

let solve1 lines =
    lines
    |> List.map ~f:split_line
    |> List.map ~f:check_line
    |> List.count ~f:Fn.id

let solve2 lines =
    lines
    |> List.map ~f:split_line
    |> List.map ~f:check_line_variants
    |> List.count ~f:Fn.id

let solve part =
    let lines = read_lines "lib/day2.in" in
    let result = match part with
        | 1 -> solve1 lines
        | 2 -> solve2 lines
        | _ -> 0
    in
    Stdio.printf "Result: %d\n" result
