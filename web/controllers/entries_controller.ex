defmodule Geminiex.EntriesController do
  use Geminiex.Web, :controller

  alias Geminiex.{Repo, Entry, ImageProcessor}

  def crop(conn, params) do
    cleaned_params = convert_and_validate_resize_params(params)

    image_src = cleaned_params["src"] || entry_image_src(cleaned_params["token"])

    case image_src do
      nil ->
        conn
          |> send_resp(400, "Cant find image source.")

      image_src ->
        procces_image_task = Task.async(fn ->
          ImageProcessor.process_image(image_src, cleaned_params)
        end)
        processed_image = Task.await(procces_image_task)

        {:ok , image_data} = File.read(processed_image.path)
        ImageProcessor.delete_temp_image(processed_image.path)
        conn
          |> put_resp_header("content-disposition", "inline")
          |> put_resp_content_type("image/jpeg") # find proper contenttype
          |> send_resp(200, image_data)
    end
  end

  defp convert_and_validate_resize_params(params) do
    width = min(String.to_integer(params["width"]), 4000)
    height = min(String.to_integer(params["height"]), 4000)
    quality = if params["quality"], do: Strin.to_integer(params["quality"])
    params
      |> Map.merge(%{"width" => width, "height" => height, "quality" => quality})
  end

  defp entry_image_src(token) do
    case Repo.get_by(Entry, token: token) do
      nil ->
        nil
      entry ->
        entry.source_url
    end
  end
end
