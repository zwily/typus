module TypusPublicHelper

  ##
  #
  #
  def quick_edit(*args)
    options = args.extract_options!
    options[:color] ||= '#000'
    html = <<-HTML
<script type="text/javascript">
  document.write('<script type="text/javascript" src="#{admin_quick_edit_url}?#{options.to_query}" />');
</script>
    HTML
    return html
  end

end