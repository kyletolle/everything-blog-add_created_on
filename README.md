# everything-blog-add_created_on

## About

This is a short script used to update my `everything` blog posts to have a consistent `created_on` attribute. The project is hacky but it helped me get to my goal of a consistent, human-readable attribute in the metadata for these blog posts. I didn't even procrastinate this until the sky caved in. That's something.

I cribbed some of the code from an in-progress branch for `everything-blog`.

For posts first created in Wordpress, I took that metadata and made it into a `created_at` attr. So it would match posts I wrote straight in `everything`. Then I converted all those `created_at` timestamps to an iso8601 date for easy readability. The metadata is more human readable this way.

I also tried to take into account changes in date when I had moved across timezones. I used the post_date_dmt values to try to be consistent, even if they're a little off. Doesn't matter too much. I only really care about the date things were published. Not the hours or seconds. And even if something is off by a day or part of a day, that's nothing terrible.

## Usage

Usage: From project directory, start irb. Then you can run the commnand to get a consistent created_at attribute, then convert that time into a created_on date attribute.

```
$ irb
> require './lib/everything/blog/add_created_on'
> Everything::Blog::AddCreatedOn.new.convert_wordpress_post_date_gmt_to_created_at
> Everything::Blog::AddCreatedOn.new.convert_created_at_to_created_on
```

## License

MIT

