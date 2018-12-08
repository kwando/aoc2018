defmodule AOC2018.Day8 do
  def run() do
    input = nodes()
    |> Enum.to_list()

    tree = input
    |> build_tree()

    tree
    |> sum_meta()
    |> IO.inspect(label: "part1")

    tree
    |> sum_2()
    |> IO.inspect(label: "part2")
  end

  def sum_2({[], meta}),          do: sum(meta)
  def sum_2({ children, meta })  do
    child_sums = Enum.map(children, &sum_2(&1))
    meta_sums  = Enum.map(meta, &by_index(child_sums, &1))
    sum(meta_sums)
  end

  def by_index([], _),                 do: 0
  def by_index([v | _], 1),            do: v
  def by_index([_ | r], n) when n > 1, do: by_index(r, n - 1)


  def sum_meta({[], meta}),       do: sum(meta)
  def sum_meta({children, meta}), do: sum(Enum.map(children, &sum_meta/1)) + sum(meta)

  def sum([]),    do: 0
  def sum([x|r]), do: x + sum(r)

  defp build_tree(data) do
    {tree, []} = build_node(data)
    tree
  end

  def build_node([0, m | data]) do
    { meta, rest } = consume(data, m)
    {{[], meta}, rest}
  end

  def build_node([c, m | data]) do
    {children, data} = Enum.reduce(1..c, {[], data}, fn(i, {res, data})->
      {node, data} = build_node(data)
      {[node | res], data}
    end)

    {meta, data} = consume(data, m)
    {{Enum.reverse(children), meta}, data}
  end

  defp consume(data, n), do: { Enum.take(data, n), Enum.drop(data, n) }

  def nodes() do
    IO.stream(:stdio, :line)
    |> Stream.flat_map(&(&1 |> String.trim() |> String.split(" ")))
    |> Stream.map(&String.to_integer/1)
  end
end

AOC2018.Day8.run()
