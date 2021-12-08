defmodule Day8 do
  def part_one do
    input = parse_input()
    input
    |> Enum.reduce(0, fn [_a,b], acc ->
      count = b |> String.split(" ", trim: true) |> Enum.filter(fn x -> count?(x) end) |> length
      count + acc
    end)
  end

  def part_two do
    input = parse_input()
    part_calculated = input
                      |> Enum.map(fn [a, b] ->
                        { part_calc(a), part_calc(b) }
                      end)

    full_calc =
      part_calculated
        |> Enum.map(fn {codes, b} ->
          lookup = calculate_values(codes, codes)

          { lookup, calculate_values(b, lookup) }
        end)

    Enum.reduce(full_calc, 0, fn {_codes, result}, acc ->
      no = Enum.map(result, fn {x,_y} -> to_string(x) end) |> Enum.join |> String.to_integer
      no + acc
    end)
  end

  def part_calc(codes) do
    codes
    |> String.split(" ", trim: true)
    |> Enum.map(fn x -> calculate_number_from_length(x) end)
  end

  def calculate_values(codes, lookup_codes) do
    lookup_codes = Map.new(lookup_codes)
    Enum.map(codes, fn {x,y} ->
      sorted_y = y |> String.split("", trim: true) |> Enum.sort |> Enum.join
      diff_4 = String.split(lookup_codes[4], "") -- String.split(lookup_codes[1], "")

      cond do
        x == [2,3,5] ->
          cond do
            length(String.split(y, "", trim: true) -- String.split(lookup_codes[1], "", trim: true)) == 3 ->
              {3, sorted_y}
            length(String.split(y, "", trim: true) -- diff_4) == 3 ->
              {5, sorted_y}
            length(String.split(y, "", trim: true) -- diff_4) == 4 ->
              {2, sorted_y}
          end
        x == [0,6,9] ->
          cond do
            length(String.split(y, "", trim: true) -- String.split(lookup_codes[1], "", trim: true)) == 5 ->
              {6, sorted_y}
            length(String.split(y, "", trim: true) -- diff_4) == 5 ->
              {0, sorted_y}
            length(String.split(y, "", trim: true) -- diff_4) == 4 ->
              {9, sorted_y}
          end
        true ->
          {x, sorted_y}
      end
    end)
  end

  def parse_input do
    { :ok, contents } = File.read("input.txt")
    contents |> String.trim |> String.split("\n") |> Enum.map(fn x -> String.split(x, "|") |> Enum.map(&String.trim/1) end)
  end

  def count?(x) do
    one?(x) || four?(x) || seven?(x) || eight?(x)
  end

  def calculate_number_from_length(x) do
    cond do
      one?(x) -> {1, x}
      four?(x) -> {4, x}
      seven?(x) -> {7, x}
      eight?(x) -> {8, x}
      true -> {potential_numbers(x), x}
    end
  end

  def one?(x) do
    String.length(x) == 2
  end

  def four?(x) do
    String.length(x) == 4
  end

  def seven?(x) do
    String.length(x) == 3
  end

  def eight?(x) do
    String.length(x) == 7
  end

  def potential_numbers(x) do
    if String.length(x) == 5 do
      [2,3,5]
    else
      [0,6,9]
    end
  end
end
