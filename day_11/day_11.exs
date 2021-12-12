defmodule Day11 do
  def part_one do
    input = parse_input()
    steps(input, 100, 0)
  end

  def steps(octopus, 0, flashes) do
    { octopus, flashes }
  end

  def steps(octopus, steps_remaining, flashes) do
    { octopus, new_flashes } = step(octopus, 0, 0)
    steps(octopus, steps_remaining - 1, flashes + new_flashes)
  end

  def step(octopus, x, y) when x == map_size(octopus) do
    step(octopus, 0, y + 1)
  end

  def step(octopus, _x, y) when y == map_size(octopus) do
    base_flashes =
      octopus
      |> Enum.reduce([], fn {i, otr}, acc ->
        Enum.filter(otr, fn {oi, ot} -> ot > 9 end)
        |> Enum.map(fn {oi, ot} -> {oi, i} end)
        |> Kernel.++(acc)
      end)

    do_flashes(octopus, base_flashes, 0)
  end

  def step(octopus, x, y) do
    octopus = increment(octopus, x, y)

    step(octopus, x + 1, y)
  end

  def do_flashes(octopus, [], count) do
    { octopus, count }
  end

  def do_flashes(octopus, flashes, count) do
    [{next_flash_x,next_flash_y}|other_flashes] = flashes
    octopus = update(octopus, next_flash_x, next_flash_y, 0)
    {octopus, flashes} = flash(octopus, {next_flash_x, next_flash_y}, {-1, -1}, other_flashes)

    do_flashes(octopus, flashes, count + 1)
  end

  def flash(octopus, {x, y}, {delta_x, delta_y}, flashes) when (x + delta_x) < 0 do
    flash(octopus, {x, y}, {delta_x + 1, delta_y}, flashes)
  end

  def flash(octopus, {x, y}, {delta_x, delta_y}, flashes) when (y + delta_y) < 0 do
    flash(octopus, {x, y}, {delta_x, delta_y + 1}, flashes)
  end

  def flash(octopus, {x, y}, {delta_x, delta_y}, flashes) when (x + delta_x) == map_size(octopus) do
    flash(octopus, {x, y}, {-1, delta_y + 1} , flashes)
  end

  def flash(octopus, {_x, y}, {_delta_x, delta_y}, flashes) when (y + delta_y) == map_size(octopus) do
    { octopus, flashes }
  end

  def flash(octopus, {x, y}, {delta_x, delta_y}, flashes) when delta_x > 1 do
    flash(octopus, {x, y}, {-1, delta_y + 1} , flashes)
  end

  def flash(octopus, _, {_delta_x, delta_y}, flashes) when delta_y > 1 do
    { octopus, flashes }
  end

  def flash(octopus, {x, y}, {delta_x, delta_y}, flashes) do
    new_x = x + delta_x
    new_y = y + delta_y
    case octopus[new_y][new_x] do
      value when value == 0 ->
        flash(octopus, {x,y}, {delta_x + 1, delta_y}, flashes)
      value when value < 9 ->
        octopus = increment(octopus, new_x, new_y)
        flash(octopus, {x,y}, {delta_x + 1, delta_y}, flashes)
      _value ->
        octopus = increment(octopus, new_x, new_y)
        new_flash = [{new_x, new_y}] -- flashes
        flash(octopus, {x,y}, {delta_x + 1, delta_y}, (new_flash ++ flashes))
    end
  end

  def update(octopus, x, y, value) do
    Map.put(octopus, y, Map.put(octopus[y], x, value))
  end

  def increment(octopus, x, y) do
    new_value = octopus[y][x] + 1
    update(octopus, x, y, new_value)
  end

  def parse_input do
    { :ok, contents } = File.read("input.txt")
    contents
    |> String.trim
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.map(fn {k,v}->{v,k |> String.to_integer} end)
      |> Map.new
    end)
    |> Enum.with_index
    |> Enum.map(fn {k,v}->{v,k} end)
    |> Map.new
  end

  def print(octopus) do
    Enum.each(octopus, fn {_i,otr} ->
      Enum.each(otr, fn {_i, ot} ->
        IO.write(ot)
      end)
      IO.puts("")
    end)
  end
end
