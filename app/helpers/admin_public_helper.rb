module AdminPublicHelper

  ##
  #
  #
  def quick_edit(*args)
    options = args.extract_options!
    options[:color] ||= '#000'
    html = <<-HTML
<script type="text/javascript">
  document.write('<script type="text/javascript" src="#{admin_quick_edit_path}?#{options.to_query}" />');
</script>
    HTML
    return html
  end

end