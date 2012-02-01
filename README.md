Socifier API gem
================

This gem lets you to integrate easily with the Socifier API

Configuration
-------------

    Socifier.config do |config|
      config.api_key = "YOUR_API_KEY"
    end

To get an API key, for now you will have to send an e-mail to [albert@acroca.com](mailto:albert@acroca.com)

Create a notification
---------------------

    Socifier.new_socification id: "your-internal-notification-id", name: "The title for the new notification", is_recurrent: true

The `id` is the unique ID for you to perform future actions on the new notification. It's not displayed anywhere.

The `name` is like the title for the notification. It it displayed everywhere in the site where your notification is displayed.

The `is_recurrent` is used to create notifications that can send multiple e-mails (like notification for new episodes on a tv show)
or only one e-mail (like when some product is released)

Subscribe your users to a notification
--------------------------------------

    Socifier.add_subscribers id: "your-internal-notification-id", emails: ["user_1@example.com", "user_2@example.com"]

Send the e-mails to the users
-----------------------------

There are two ways to send the e-mails, depending on the `is_recurrent` value.

### For recurrent notifications

When a notification is recurrent you have to actions to perform. One is `send_mail` witch just sends the e-mail but keeps
the notification open for future e-mails. It doesn't change the status of the notification.

    Socifier.send_mail id: "your-internal-notification-id"

When the event has finished, like when a tv show ends forever, you can close the notification to prevent new users to subscribe it.
It changes the state of the notification to *closed*. It doesn't any e-mail to the users in that case.

    Socifier.close id: "your-internal-notification-id"

### For normal notifications

When a notification is not recurrent you can only close it. In that case, the close action sends the e-mail and closes the
notification at the same time.

    Socifier.close id: "your-internal-notification-id"