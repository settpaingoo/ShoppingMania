# Shopping Mania

This is a demo app developed as the final project while the developer was learning web development at App Academy. This is a clone of an online clothing store (Macy's or JCPenny, for example) built on Ruby on Rails. [Start shopping] (http://www.shoppingmania.us)

## Features

### Browsing items

*Multiple items*
* Search/filter items by name, price, brand, category, and rating.
* Sort items by price, date of arrival, rating, or popularity.
* Chain lazy "where" and "order" methods to create one query that actually queries the database.
* Prefetch item photos and ratings to avoid (n + 1) queries.

*Individual item*
* All photos of the item are displayed in thumbnail view and the "main" photo is displayed in larger view.
* Clicking on a thumbnail photo displays it in larger view.
* The source url of each photo is stored in data-url attribute. Clicking on a photo changes the image source of the large view to the source url of the photo clicked.
* Rating of each item is cached for faster retrieval as well as to avoid querying the database unnecessarily. * For this demo app, cached ratings expire after an hour.

### Adding items to cart/Saving items
*Logged in*
* Make ajax call to the server and give feedback (success/failure) without refreshing the page.
*Not logged in*
* Store the item id and quantity in the cookies.

### Reviews/Ratings
* Users can write reviews and give rating for items they've bought.

### Wishlist
* Logged in users can create wishlists and add/remove items to/from their wishlists as well as move wishlist items to cart.
* Make ajax calls without refreshing the page.

### Other features
* Admins have privilege to add/delete/edit items.
* Users can save addresses to use upon checkout.
* View past orders.
* Log in with facebook. (Omniauth)

## Future plans

* Alert users via notifications if the price of items in their cart or saved items change.
* Allow users to subscribe to out-of-stock items and send email when the item is back in stock.
* Keep track of browsing history and display related/recommended items.
* Expand to other departments (like Amazon).