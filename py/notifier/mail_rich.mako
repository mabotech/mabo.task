# -*- coding: utf-8 -*-
<html>
<body>      
${title},您好！<br/><br/>

以下网站内容更新，请您点击阅读:<br/><br/>

% for site in sites:
<a href="${site["url"]}">${site["name"]}</a><br/>
% endfor
<br/>
Best Regards!<br/><br/>

</body>
</html>