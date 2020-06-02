defmodule RedealWeb.DealController do
  use RedealWeb, :controller
  alias Redeal.DealHandler, as: Handler

  def get_deal(conn, params) do
    opening = Map.get(params, "opening")
    deal = Handler.get_deal(opening)

    text(conn, deal)
  end
end
