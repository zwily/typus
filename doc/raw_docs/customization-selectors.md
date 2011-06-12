# Selectors

Form selectors are using the instance method `to_label`:

    def to_label
      if respond_to?(:name) && send(:name).present?
        send(:name)
      else
        [self.class, id].join("#")
      end
    end

This means that having the following `ActiveRecord::Base` class:

    class Entry < ActiveRecord::Base
      # Attributes: title, content
    end

Selectors will look like this:

    Entry#1
    Entry#2
    Entry#3

Defining the method `to_label` allows you to show the information you want to:

    class Entry < ActiveRecord::Base
      # Attributes: title, author, content

      def to_label
        "#{title} (#{author})"
      end
    end
