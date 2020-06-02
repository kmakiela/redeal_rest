defmodule RedealWeb.PageController do
  use RedealWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
