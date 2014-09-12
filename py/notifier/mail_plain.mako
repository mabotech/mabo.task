# -*- coding: utf-8 -*-
${title},您好！

以下网站内容更新，请您阅读:

% for site in sites:
[${site["name"]}](${site["url"]})

% endfor

Best Regards!