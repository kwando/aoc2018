#!/usr/bin/env elixir
defmodule AOC2018.Day2 do
  def part_one do
    get_input()
    |> Enum.map(&count_letters/1)
    |> Enum.reduce({0, 0}, &checksum_values/2)
    |> calculate_checksum()
    |> IO.inspect(label: "part 1")
  end

  def calculate_checksum({n, m}), do: n * m
  def checksum_values(map, {twos, threes}) do
    {twos + has_value(map, 2), threes + has_value(map, 3)}
  end

  defp has_value(map, key) do
    if Map.has_key?(map, key) do
      1
    else
      0
    end
  end

  def count_letters(input) do
    input
    |> String.codepoints()
    |> Enum.sort()
    |> letter_counter({1, Map.new})
  end

  defp letter_counter([], {_, result}) do
    result
  end

  defp letter_counter([ n | rest ], { count, result }) do
    case rest do
      [ ^n  | _ ] -> letter_counter(rest, { count + 1, result })
      _ -> letter_counter(rest, { 1 , Map.put(result, count, n) })
    end
  end

  def get_input() do
    File.read!("./input.txt")
    |> String.split("\n", trim: true)
  end

  def part_two() do
    codes = get_input()
    |> Enum.map(&String.codepoints/1)

    for c1 <- codes, c2 <- codes do
      compute_difference(c1, c2)
      |> case do
        1 ->
          IO.inspect(compute_common(c1, c2), label: "part2")
        _ -> :ok
      end
    end
  end

  defp compute_difference(id1, id2),                       do: compute_difference(id1, id2, 0)
  defp compute_difference([], [], diff),                  do: diff
  defp compute_difference([n | r1], [n | r2], diff),      do: compute_difference(r1, r2, diff)
  defp compute_difference([ _ | r1 ], [ _ | r2 ], diff),  do: compute_difference(r1, r2, diff + 1)

  defp compute_common(c1, c2),                            do: compute_common(c1, c2, [])
  defp compute_common([], [], common),                    do: common |> Enum.reverse() |> Enum.join()
  defp compute_common([n | r1], [n | r2], common),        do: compute_common(r1, r2, [n | common])
  defp compute_common([_ | r1], [_ | r2], common),        do: compute_common(r1, r2, common)
end

AOC2018.Day2.part_one()
AOC2018.Day2.part_two()
