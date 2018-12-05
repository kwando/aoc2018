defmodule AOC2018.Day5 do
  def run() do
    input = IO.read(:stdio, :line)
    |> String.to_charlist()

    input
    |> reduce_all()
    |> Enum.count
    |> IO.inspect(label: "part 1")

    (?A..?Z)
    |> Task.async_stream(fn(char)->
      result = input
      |> Enum.filter(&( &1 != char && &1 != char + 32))
      |> reduce_all()

      {Enum.count(result), List.to_string([char])}
    end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.min_by(fn({length, _})-> length end)
    |> IO.inspect(label: "part 2")
  end

  def reduce_all(list) when is_list(list), do: reduce_all(reduce(list))
  def reduce_all({result, 0}), do: result
  def reduce_all({result, _}), do: reduce_all(reduce(result))

  def reduce(list), do: reduce(list, {[], 0})
  def reduce([], {result, count}), do: {Enum.reverse(result), count}

  def reduce([m, n | rest], {result, count}) when abs(m - n) == 32 do
    reduce(rest, {result, count + 1})
  end

  def reduce([m | rest], {result, count}) do
    reduce(rest, {[m | result], count})
  end
end

AOC2018.Day5.run()
