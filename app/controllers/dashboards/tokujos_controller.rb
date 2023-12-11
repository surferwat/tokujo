class Dashboards::TokujosController < ApplicationController
  def index
    authorize :dashboard, :index?

    tokujo = Current.user.tokujos.find(params[:id]) # where returns [] if no match

    # Generate QR code
    tokujo_sales_url = url_for(action: "show", controller: "/tokujo_sales", tokujo_id: tokujo.id, only_path: false)
    tokujo_sales_qr_code = RQRCode::QRCode.new(tokujo_sales_url)
    tokujo_sales_qr_code_png = tokujo_sales_qr_code.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 240
    )

    # Set instance variables for view
    @tokujo_sales_url = tokujo_sales_url
    @tokujo_sales_qr_code_png_url = tokujo_sales_qr_code_png.to_data_url
    @tokujo = tokujo
  end
end
