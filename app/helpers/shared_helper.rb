module SharedHelper
  def form_page_container_class(custom_part=nil, common_part="mt-8 sm:mx-auto sm:w-full")
    "#{custom_part || "sm:max-w-md"} #{common_part}"
  end
end