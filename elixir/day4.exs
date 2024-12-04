import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day4 do
  def find_horizontal(list) do
    for l <- list do
      ~r/XMAS/
      |> Regex.scan(l)
      |> Enum.count()
    end
  end

  def find_with_index(str, to_find) do
    str
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {c, _} -> c == to_find end)
  end

  def get_coord(lines, {x, y}) do
    String.at(Enum.at(lines, y), x)
  end

  def attach_delta({[{x, y} | tl], {dx, dy}}) do
    [{x + dx, y + dy}, {x, y} | tl]
  end

  def find_around([], _, _) do
    []
  end

  def find_around(indices, lines, to_find) do
    # If we kept track of the delta for each row, we could only search in that direction to keep it simpler
    deltas = [{-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}]

    for(
      x <- indices,
      y <- deltas,
      do: {x, y}
    )
    |> Enum.map(&Day4.attach_delta/1)
    |> Enum.filter(fn [{x, y} | _] ->
      x >= 0 && y >= 0 && x < String.length(Enum.at(lines, 0)) && y < length(lines) &&
        get_coord(lines, {x, y}) == to_find
    end)
  end

  def find_all(list, to_find) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      line
      |> find_with_index(to_find)
      |> Enum.map(fn {_, x} ->
        {x, y}
      end)
    end)
    |> List.flatten()
    |> Enum.map(fn c -> [c] end)
  end

  def is_straight([_], _) do
    true
  end

  def is_straight([{x1, y1}, {x2, y2} | tl], delta) do
    {x2 - x1, y2 - y1} == delta && is_straight([{x2, y2} | tl], delta)
  end

  def is_straight(coords) do
    [{x1, y1}, {x2, y2} | tl] = coords
    delta = {x2 - x1, y2 - y1}
    is_straight([{x2, y2} | tl], delta)
  end

  def solve1(input) do
    input
    |> find_all("X")
    |> find_around(input, "M")
    |> find_around(input, "A")
    |> find_around(input, "S")
    |> Enum.filter(&Day4.is_straight/1)
    |> Enum.count()
  end

  def find_cross(indices, lines, to_find) do
    # We only need to search the corners now
    deltas = [{-1, 1}, {1, 1}, {-1, -1}, {1, -1}]

    for(
      x <- indices,
      y <- deltas,
      do: {x, y}
    )
    |> Enum.map(&Day4.attach_delta/1)
    |> Enum.filter(fn [{x, y} | _] ->
      x >= 0 && y >= 0 && x < String.length(Enum.at(lines, 0)) && y < length(lines) &&
        get_coord(lines, {x, y}) == to_find
    end)
  end

  def solve2(input) do
    list =
      input
      |> find_all("M")
      |> find_cross(input, "A")
      |> find_cross(input, "S")
      |> Enum.filter(&Day4.is_straight/1)

    # There probably is a way to do this and the filter in one go, but this works and was very easy to come up with
    for(
      x <- list,
      y <- list,
      x < y,
      do: {x, y}
    )
    |> Enum.filter(fn {[_, {x1, y1}, _], [_, {x2, y2}, _]} -> x1 == x2 && y1 == y2 end)
    |> Enum.count()
  end
end

IO.puts("Testing examples pt 1")

assert(
  [{2, 2}, {1, 1}] =
    Day4.attach_delta({
      [{1, 1}],
      {1, 1}
    })
)

assert(
  "H" =
    Day4.get_coord(
      [
        "ABCDEFG",
        "HIJKLMN",
        "OPQRSTU",
        "VWXYZ01",
        "2345678"
      ],
      {0, 1}
    )
)

assert(
  "R" =
    Day4.get_coord(
      [
        "ABCDEFG",
        "HIJKLMN",
        "OPQRSTU",
        "VWXYZ01",
        "2345678"
      ],
      {3, 2}
    )
)

assert(
  [[{3, 2}, {3, 1}], [{3, 0}, {3, 1}]] =
    Day4.find_around(
      [[{3, 1}]],
      [
        "MMMSXXMASM",
        "MSAMXMSMSA",
        "AMXSXMAAMM",
        "MSAMASMSMX"
      ],
      "S"
    )
)

assert [[{4, 0}], [{5, 0}]] =
         Day4.find_all(["MMMSXXMASM"], "X")

assert(
  18 =
    Day4.solve1([
      "MMMSXXMASM",
      "MSAMXMSMSA",
      "AMXSXMAAMM",
      "MSAMASMSMX",
      "XMASAMXAMM",
      "XXAMMXXAMA",
      "SMSMSASXSS",
      "SAXAMASAAA",
      "MAMMMXMMMM",
      "MXMXAXMASX"
    ])
)

IO.puts("Ok")

input = Utils.read_lines("day4.in")
result = Day4.solve1(input)
IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt 2")

Day4.solve2([
  "MMMSXXMASM",
  "MSAMXMSMSA",
  "AMXSXMAAMM",
  "MSAMASMSMX",
  "XMASAMXAMM",
  "XXAMMXXAMA",
  "SMSMSASXSS",
  "SAXAMASAAA",
  "MAMMMXMMMM",
  "MXMXAXMASX"
])

assert(
  9 =
    Day4.solve2([
      "MMMSXXMASM",
      "MSAMXMSMSA",
      "AMXSXMAAMM",
      "MSAMASMSMX",
      "XMASAMXAMM",
      "XXAMMXXAMA",
      "SMSMSASXSS",
      "SAXAMASAAA",
      "MAMMMXMMMM",
      "MXMXAXMASX"
    ])
)

IO.puts("Ok")

input = Utils.read_lines("day4.in")
result = Day4.solve2(input)
IO.puts("Result pt2: #{result}")
