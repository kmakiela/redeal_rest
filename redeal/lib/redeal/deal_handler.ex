defmodule Redeal.DealHandler do
  @moduledoc """
  empty
  """
  alias Redeal.RabbitHandler

  defdelegate get_deal(opening), to: RabbitHandler
end
