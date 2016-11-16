defmodule Permutation do
  @moduledoc """
  Functions that work on circular permutation.

  In mathematics, the notion of permutation relates to the act of arranging all
  the members of a set into some sequence or order, or if the set is already
  ordered, rearranging (reordering) its elements, a process called permuting.

  A circular permutation means the last element has for successor the first.
  """

  @typedoc """

  """
  @type t :: []
  @type element :: any
  @type acc :: term

  @doc """
  Returns a list where each item is the result of invoking fun on each
  corresponding edge of permutation.

  Note that since the successeur of the last element in the permutation is the
  first element, the last considered edge is {last, first}

  ## Examples

      iex> Permutation.edge_map([1, 2, 3], &(&1 + &2))
      [3, 5, 4]

      iex> Permutation.edge_map([1, 2, 3], &(&1 * &2))
      [2, 6, 3]

  """
  @spec edge_map(t, (element, element -> any)) :: list

  def edge_map([],            _), do: []
  def edge_map(permutation, fun) do
    fun = fn (pred, succ, acc) ->
      [fun.(pred, succ) | acc]
    end
    edge_reduce(permutation, [], fun) |> :lists.reverse()
  end

  @doc """
  Invokes fun for each edge in the permutation, passing that element and the
  accumulator as arguments. fun’s return value is stored in the accumulator.

  ## Examples

      iex> Permutation.edge_reduce([1, 2, 3], 0, &(&1 + &2 + &3))
      12

      iex> Permutation.edge_reduce([1, 2, 3], [], &([&1 + &2 | &3]))
      [4, 5, 3]

  """
  @spec edge_reduce(t, acc, (element, element, acc -> any)) :: list
  def edge_reduce(permutation, acc, fun) do
     do_edge_reduce(permutation, nil, acc, fun)
  end

  @spec edge_map(t, (element, element, acc -> any)) :: list
  defp do_edge_reduce([],               _, acc, _), do: acc
  defp do_edge_reduce([pred|succs], first, acc, fun) do
    first = first || pred
    case succs do
      [] ->
        fun.(pred, first, acc)
      [succ|_] ->
        do_edge_reduce(succs, first, fun.(pred, succ, acc), fun)
    end
  end

  # def swap([ ], _, _), do: [ ]
  # def swap(permutation, left_idx, left_idx), do: permutation
  #
  # def swap(permutation, left_idx, right_idx) do
  #   permutation
  #   |> List.replace_at(left_idx, nth(list, right_idx))
  #   |> List.replace_at(right_idx, nth(list, left_idx))
  # end
  #
  # def nth(list, idx) when is_number(idx) and idx < 0 do
  #   throw 'Index must be positive'
  # end
  #
  # def nth(list, idx) when idx > length(list) - 1 do
  #   throw ' index bigger the list size'
  # end
  #
  # def nth([ element | _ ] , 0), do: element
  # def nth([ head | tail ], idx), do: nth(tail, idx - 1)

end
