defmodule Day4 do
  def part_one do
    {numbers, boards} = parse_input()

    boards
    |> find_winner(numbers)
    |> calculate_score()
  end

  def part_two do
    {numbers, boards} = parse_input()

    boards
    |> last_winner(numbers)
    |> calculate_score()
  end

  defp parse_input do
    { :ok, contents } = File.read("input.txt")
    [numbers|boards] = contents |> String.trim |> String.split("\n\n")

    numbers = numbers |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    boards =
      boards
      |> Enum.map(fn x -> String.split(x, "\n")
      |> Enum.map(fn x -> String.split(x) |> Enum.map(&String.to_integer/1) end) end)

    {numbers, boards}
  end

  defp find_winner(boards, numbers, pulled_numbers \\ []) do
    [next_number|remaining] = numbers

    pulled_numbers = [next_number|pulled_numbers]
    winning_board = Enum.find(boards, fn
      board ->
        row_winner?(board, pulled_numbers) || column_winner?(board, pulled_numbers)
    end)

    if winning_board do
      {winning_board, pulled_numbers}
    else
      find_winner(boards, remaining, pulled_numbers)
    end
  end

  defp last_winner(boards, numbers, pulled_numbers \\ []) do
    [next_number|remaining] = numbers

    pulled_numbers = [next_number|pulled_numbers]
    losing_boards = Enum.reject(boards, fn
      board ->
        row_winner?(board, pulled_numbers) || column_winner?(board, pulled_numbers)
    end)

    if Enum.any?(losing_boards) do
      last_winner(losing_boards, remaining, pulled_numbers)
    else
      {List.first(boards), pulled_numbers}
    end
  end

  defp row_winner?(board, pulled_numbers) do
    board
    |> Enum.any?(fn row -> (row -- pulled_numbers) |> Enum.empty? end)
  end

  defp column_winner?(board, pulled_numbers) do
    column_height = length(board)
    row_length = List.first(board) |> length()

    for x <- 0..(row_length - 1) do
      column =
        for y <- 0..(column_height - 1) do
          Enum.at(board, y) |> Enum.at(x)
        end

      (column -- pulled_numbers) |> Enum.empty?
    end |> Enum.any?
  end

  defp calculate_score({winning_board, numbers}) do
    winning_board
    |> List.flatten()
    |> Enum.reject(&(&1 in numbers))
    |> Enum.sum
    |> Kernel.*(List.first(numbers))
  end
end
