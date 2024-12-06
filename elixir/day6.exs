import ExUnit.Assertions
Code.require_file("utils.exs")

defmodule Day6 do
  def find_pos(line, c, y) do
    result =
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {v, _} -> c == v end)

    if Enum.count(result) > 0 do
      {_, x} = List.first(result)
      {x, y}
    else
      nil
    end
  end

  def find_pos(state, c) do
    state
    |> Enum.with_index()
    |> Enum.map(fn {l, y} -> find_pos(l, c, y) end)
    |> Enum.filter(fn l -> l != nil end)
    |> List.first()
  end

  def find_all(line, c, y) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {v, _} -> c == v end)
    |> Enum.map(fn {_, x} -> {x, y} end)
  end

  def find_all(state, c) do
    state
    |> Enum.with_index()
    |> Enum.map(fn {l, y} -> find_all(l, c, y) end)
    |> Enum.filter(fn l -> Enum.count(l) > 0 end)
    |> List.flatten()
  end

  def clean_map(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn c ->
      if c != "#" do
        "."
      else
        "#"
      end
    end)
  end

  def create_map(state) do
    state
    |> Enum.map(&Day6.clean_map/1)
  end

  def map_at(state, {x, y}) do
    if y >= 0 && y < Enum.count(state) && x >= 0 && x < Enum.count(List.first(state)) do
      Enum.at(Enum.at(state, y), x)
    else
      nil
    end
  end

  def next_pos({x, y}, "^") do
    {x, y - 1}
  end

  def next_pos({x, y}, ">") do
    {x + 1, y}
  end

  def next_pos({x, y}, "v") do
    {x, y + 1}
  end

  def next_pos({x, y}, "<") do
    {x - 1, y}
  end

  def next_dir("^") do
    ">"
  end

  def next_dir(">") do
    "v"
  end

  def next_dir("v") do
    "<"
  end

  def next_dir("<") do
    "^"
  end

  def simulate(pos, dir, map, history) do
    next = next_pos(pos, dir)

    case map_at(map, next) do
      "." -> simulate(next, dir, map, [pos | history])
      "#" -> simulate(pos, next_dir(dir), map, history)
      _ -> [pos | history]
    end
  end

  def solve1(lines) do
    start =
      find_pos(lines, "^")

    map = create_map(lines)

    simulate(start, "^", map, [])
    |> Enum.uniq()
    |> Enum.count()
  end

  def simulate_loop(pos, dir, map, historymap) do
    key =
      dir <> inspect(pos)

    if(MapSet.member?(historymap, key)) do
      # This is a loop
      true
    else
      next = next_pos(pos, dir)
      # IO.puts("Checking: #{inspect(pos)}, #{dir} -> #{inspect(next)}")

      case map_at(map, next) do
        "." -> simulate_loop(next, dir, map, MapSet.put(historymap, key))
        "#" -> simulate_loop(pos, next_dir(dir), map, historymap)
        _ -> false
      end
    end
  end

  def detect_loop(map, pos) do
    simulate_loop(pos, "^", map, MapSet.new())
  end

  def is_loop(input) do
    start = find_pos(input, "^")
    map = create_map(input)
    Day6.detect_loop(map, start)
  end

  def generate_variants(map, {sx, sy}) do
    for {l, y} <- Enum.with_index(map),
        {val, x} <- Enum.with_index(l),
        val == "." && (x != sx || y != sy) do
      place_obstacle(map, x, y)
    end
  end

  def place_obstacle(map, x, y) do
    List.update_at(map, y, fn l ->
      List.update_at(l, x, fn _ -> "#" end)
    end)
  end

  def solve2(lines) do
    start =
      find_pos(lines, "^")

    create_map(lines)
    |> generate_variants(start)
    |> Enum.map(fn m -> detect_loop(m, start) end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end

# IO.puts("Testing examples pt 1")

testinput = [
  ".#..#....#",
  ".........#",
  "..........",
  "..#.......",
  ".......#..",
  "..........",
  ".#..^.....",
  "........#.",
  "#.........",
  "......#..."
]

# assert({4, 6} = Day6.find_pos(testinput, "^"))
#
# assert(
#   41 =
#     Day6.solve1(testinput)
# )
#
# IO.puts("Ok")
#
# input = Utils.read_lines("day6.in")
# result = Day6.solve1(input)
# IO.puts("Result pt1: #{result}")

IO.puts("Testing examples pt 2")

assert(
  true =
    Day6.is_loop([
      "....#.....",
      ".........#",
      "..........",
      "..#.......",
      ".......#..",
      "..........",
      ".#.#^.....",
      "........#.",
      "#.........",
      "......#..."
    ])
)

assert(
  true =
    Day6.is_loop([
      "....#.....",
      ".........#",
      "..........",
      "..#.......",
      ".......#..",
      "..........",
      ".#..^.....",
      ".......##.",
      "#.........",
      "......#..."
    ])
)

assert(
  2 =
    Enum.count(
      Day6.generate_variants(
        [
          [".", "#"],
          [".", "."]
        ],
        {1, 1}
      )
    )
)

assert(
  3 =
    Enum.count(
      Day6.generate_variants(
        [
          [".", "."],
          [".", "."]
        ],
        {1, 1}
      )
    )
)

assert(6 = Day6.solve2(testinput))

IO.puts("Ok")

input = Utils.read_lines("day6.in")
result = Day6.solve2(input)
IO.puts("Result pt2: #{result}")
