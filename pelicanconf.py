AUTHOR = 'junehan'
SITENAME = 'junehan.dev.log'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Asia/Seoul'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('github', 'https://github.com/junehan-dev'),
         ('study blog', 'https://junehan-dev.github.io/doc'),
        )
# Social widget
SOCIAL = (('github', 'https://github.com/junehan-dev/'),
#          ('Another social link', '#'),)
        )
DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# CUSTOM
THEME = 'themes/graymill'

PAGE_URL = 'pages/{category}/'
PAGE_SAVE_AS = 'pages/{category}/index.html'
ARTICLE_URL = 'posts/{category}/{date:%Y}/{date:%m}/{date:%d}/{slug}'
ARTICLE_SAVE_AS = 'posts/{category}/{date:%Y}/{date:%m}/{date:%d}/{slug}.html'

