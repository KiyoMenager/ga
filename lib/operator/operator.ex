defmodule Ga.Operator do
  @moduledoc ~S"""
  Specification of the operator behaviour.
  """
  @type callback :: (list -> any)


  @doc """
  Returns a callable operator.
  """
  @callback get_callback() :: callback
end
