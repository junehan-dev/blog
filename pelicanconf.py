AUTHOR = 'junehan'
SITENAME = 'Junehan devlog'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Asia/Seoul'

DEFAULT_LANG = 'en'
THEME = "themes/graymill"
#THEME = "/home/junehan/pelican-themes/pelican-cait"
#THEME = "/home/junehan/pelican-themes/clean-blog"
# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (
            ('Books Read', 'https://junehan.github.io/doc'),
            ('Traslations or study for a books interested', '#'),
        )

# Social widget
SOCIAL = (
             ('github', 'https://github.com/junehan-dev'),
            #('linkedin', 'https://www.linkedin.com/in/username'),
         )
DEFAULT_PAGINATION = 8

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

FAVICON = 'images/favicon.png'

# github page
OUTPUT_PATH = 'output'
PATH = 'content'
