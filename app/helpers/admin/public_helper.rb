module Admin

  module PublicHelper

    def quick_edit(*args)

      options = args.extract_options!

      <<-HTML
<script type="text/javascript">
  document.write('<script type="text/javascript" src="#{admin_quick_edit_path}?#{options.to_query}" />');
</script>
      HTML

    end

  end

end