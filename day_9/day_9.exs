defmodule Day9 do
  def part_one do
    input = parse_input
    input
    |> Enum.with_index
    |> Enum.reduce(0, fn {depths,y}, acc ->
      a = depths
      |> Enum.with_index
      |> Enum.filter(fn {depth, x} ->
        zz = for ay <- -1..1 do
        if y + ay >= 0 && Enum.at(input, y + ay) do
            for ax <- -1..1 do
            require IEx; IEx.pry
              (Enum.at(input, y) |> Enum.at(x + ax) || -1) < depth
            end
          else
            true
          end
        end |> List.flatten |> Enum.all?
        require IEx; IEx.pry
        zz
      end)
      |> Enum.map(& &1 + 1)
      |> Enum.sum
      # |> Kernel.+(acc)
      require IEx; IEx.pry
      a + acc
    end)
  end

  def parse_input do
    { :ok, contents } = File.read("test_input.txt")
    contents |> String.trim |> String.split("\n") |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  end
end

Day9.part_one
