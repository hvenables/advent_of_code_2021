{ :ok, contents } = File.read("input.txt")
contents = contents |> String.trim |> String.split("\n") |> Enum.map(fn x -> String.split(x, " ") end)

defmodule SubmarineCourse do
  def travel(["forward", amount], %{depth: depth, horizontal: horizontal}) do
    amount = String.to_integer(amount)
    %{depth: depth, horizontal: horizontal + amount}
  end

  def travel(["down", amount], %{depth: depth, horizontal: horizontal}) do
    amount = String.to_integer(amount)
    %{depth: depth + amount, horizontal: horizontal}
  end

  def travel(["up", amount], %{depth: depth, horizontal: horizontal}) do
    amount = String.to_integer(amount)
    %{depth: depth - amount, horizontal: horizontal}
  end

  def steer(["forward", amount], %{aim: aim, depth: depth, horizontal: horizontal}) do
    amount = String.to_integer(amount)
    %{aim: aim, depth: depth + (aim * amount), horizontal: horizontal + amount}
  end

  def steer(["down", amount], %{aim: aim, depth: depth, horizontal: horizontal}) do
    amount = String.to_integer(amount)
    %{aim: aim + amount, depth: depth, horizontal: horizontal}
  end

  def steer(["up", amount], %{aim: aim, depth: depth, horizontal: horizontal}) do
    amount = String.to_integer(amount)
    %{aim: aim - amount, depth: depth, horizontal: horizontal}
  end
end

final_position = contents |> Enum.reduce(%{depth: 0, horizontal: 0}, &SubmarineCourse.travel/2)
IO.puts final_position[:depth] * final_position[:horizontal]

final_position = contents |> Enum.reduce(%{aim: 0, depth: 0, horizontal: 0}, &SubmarineCourse.steer/2)
IO.puts final_position[:depth] * final_position[:horizontal]
