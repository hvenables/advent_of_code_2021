{ :ok, contents } = File.read("input.txt")
contents = contents |> String.trim |> String.split("\n") |> Enum.map(&String.to_integer/1)

contents
|> Enum.chunk_every(2, 1, :discard)
|> Enum.reduce(0, fn([a, b], acc) -> if b > a, do: acc + 1, else: acc end)
|> IO.puts

contents
|> Enum.chunk_every(3, 1, :discard)
|> Enum.chunk_every(2, 1, :discard)
|> Enum.reduce(0, fn([a, b], acc) -> if Enum.sum(b) > Enum.sum(a), do: acc + 1, else: acc end)
|> IO.puts
