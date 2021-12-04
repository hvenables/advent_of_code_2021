{ :ok, contents } = File.read("input.txt")
contents = contents |> String.trim |> String.split("\n") |> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.map(&String.to_integer/1) end)

# Part 1
combined_values =
  contents
  |> Enum.reduce([0,0,0,0,0,0,0,0,0,0,0,0], fn b, acc ->
    for x <- 0..11 do
      Enum.at(b, x) + Enum.at(acc, x)
    end
  end)

total_length = length(contents)
gamma_rate =
  for x <- 0..11 do
    if Enum.at(combined_values, x) < (total_length / 2), do: 0, else: 1
  end |> Enum.join() |> String.to_integer(2)

epsilon_rate =
  for x <- 0..11 do
    if Enum.at(combined_values, x) > (total_length / 2), do: 0, else: 1
  end |> Enum.join() |> String.to_integer(2)

IO.puts(gamma_rate * epsilon_rate)

# Part 2
Stream.unfold({contents, 0}, fn
  {[x],_position} ->
    IO.puts Enum.join(x) |> String.to_integer(2)
    nil
  {x,position}  ->
    content_size = length(x)
    total_at_position =
      x |> Enum.reduce(0, fn n, acc -> Enum.at(n, position) + acc end)

    # switch to < for reverse
    most_common = if total_at_position >= (content_size/2), do: 1, else: 0
    new_list = Enum.filter(x, fn n -> Enum.at(n, position) == most_common end)

    {{ x, position }, {new_list, position + 1}}
end) |> Enum.to_list
