defmodule Ga.Operator do
  @moduledoc ~S"""
  Specification of the operator behaviour.
  """

  @doc """
  Returns a callable operator.
  """
  @callback run_callback() :: (list -> list)
end
