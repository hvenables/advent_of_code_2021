defmodule Day10 do

  def part_one do
    input = parse_input()
    input
    |> Enum.reduce(0, fn line, acc ->
      with {true, {char, _expected}}<- find_error(line, [], nil) do
        score()[char] + acc
      else
        _ ->
          acc
      end
    end)
  end

  def part_two do
    input = parse_input()
    a = input
    |> Enum.reduce([], fn line, acc ->
      with {false, missing}<- find_error(line, [], nil) do
        x = Enum.reduce(missing, 0, fn x, iacc -> (iacc * 5) + missing_score()[x] end)
        [x|acc]
      else
        _ ->
          acc
      end
    end)
    a |> Enum.sort |> Enum.at(div(length(a),2))
  end

  def find_error([], next_closing, nil), do: {false,next_closing}

  def find_error(line, next_closing, nil) do
    [next_char|rest] = line
    if opening?(next_char) do
      find_error(rest, [closing[next_char]|next_closing], nil)
    else
      [expected|rest_closing] = next_closing
      if expected == next_char do
        find_error(rest, rest_closing, nil)
      else
        find_error(rest, rest_closing, {next_char, expected})
      end
    end
  end
  def find_error(line, next_closing, error), do: {true, error}

  def parse_input do
    { :ok, contents } = File.read("input.txt")
    contents
    |> String.trim
    |> String.split("\n", trim: true)
    |> Enum.map(& &1 |> String.split("", trim: true))
  end

  def closing do
    %{
      "(" => ")",
      "{" => "}",
      "<" => ">",
      "[" => "]"
    }
  end

  def score do
    %{
      ")" => 3,
      "]" => 57,
      "}" => 1197,
      ">" => 25137,
    }
  end

  def missing_score do
    %{
      ")" => 1,
      "]" => 2,
      "}" => 3,
      ">" => 4,
    }
  end

  def opening?(char) do
    Enum.member?(["[", "(", "<", "{"], char)
  end
end
