class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def label(object_name, method_name = "", options = {})
    default_options = { class: "block text-sm font-medium text-slate-800" }
    merged_options = default_options.merge(options)
    super(object_name, method_name, merged_options)
  end

  def text_field(method_name, options={})
    default_options = { class: "w-full px-3 py-3 border border-slate-400 rounded-md shadow-sm text-base placeholder-gray-400 focus:outline-none focus:ring-gray-900 focus:border-gray-900" }
    merged_options = default_options.merge(options)
    super(method_name, merged_options)
  end

  def number_field(method_name, options={})
    default_options = { class: "appearance-none block w-full px-3 py-3 border border-slate-400 rounded-md shadow-sm text-base placeholder-gray-400 focus:outline-none focus:ring-gray-900 focus:border-gray-900" }
    merged_options = default_options.merge(options)
    super(method_name, merged_options)
  end

  def date_field(method_name, options={})
    default_options = { class: "appearance-none block w-full px-3 py-3 border border-slate-400 rounded-md shadow-sm text-base placeholder-gray-400 focus:outline-none focus:ring-gray-900 focus:border-gray-900" }
    merged_options = default_options.merge(options)
    super(method_name, merged_options)
  end

  def password_field(method_name, options={})
    default_options = { class: "appearance-none block w-full px-3 py-3 border border-slate-400 rounded-md shadow-sm text-base placeholder-gray-400 focus:outline-none focus:ring-gray-900 focus:border-gray-900" }
    merged_options = default_options.merge(options)
    super(method_name, merged_options)
  end
  
  def select(object_name, method_name, choices = nil, options = {}, html_options = {}, &block)
    default_options = { class: "appearance-none block w-full px-3 py-3 border border-slate-400 rounded-md shadow-sm text-base placeholder-gray-400 focus:outline-none focus:ring-gray-900 focus:border-gray-900" }
    merged_options = default_options.merge(options)
    super(object_name, method_name, choices, merged_options)
  end

  def submit(value, options={})
    default_options = { class: "min-w-24 w-full flex flex-1 justify-center py-3 px-6 rounded-md shadow-sm text-white text-base font-medium bg-slate-800 cursor-pointer hover:bg-gray-900" }
    merged_options = default_options.merge(options)
    super(value, merged_options)
  end
end