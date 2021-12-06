defmodule Day6 do
  def part_one do
    fish = parse_input()
    fish_count = {0,0,0,0,0,0,0,0,0}

    fish_count = Enum.reduce(fish, fish_count, fn x, acc ->
      value = elem(acc, x)
      put_elem(acc, x, value + 1)
    end)

    result = pass_a_day(fish_count, 80)
    sum_count(result)
  end

  def part_two do
    fish = parse_input()
    fish_count = {0,0,0,0,0,0,0,0,0}

    fish_count = Enum.reduce(fish, fish_count, fn x, acc ->
      value = elem(acc, x)
      put_elem(acc, x, value + 1)
    end)

    result = pass_a_day(fish_count, 256)
    sum_count(result)
  end

  def pass_a_day(fish_count, 0) do
    fish_count
  end

  def pass_a_day(fish_count, days_left) do
    update_count = Enum.reduce(8..0, fish_count, fn age, acc ->
      if age > 0 do
        put_elem(acc, age - 1, elem(fish_count, age))
      else
        acc = put_elem(acc, 8, elem(fish_count, age))
        put_elem(acc, 6, elem(fish_count, age) + elem(acc, 6))
      end
    end)

    pass_a_day(update_count, days_left - 1)
  end

  def sum_count(fish_count) do
    for i <- 0..8 do
      elem(fish_count, i)
    end |> Enum.sum
  end

  def parse_input do
    { :ok, contents } = File.read("input.txt")
    contents |> String.trim |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
