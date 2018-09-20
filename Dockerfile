FROM python

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential python3-dev python3-pip python3-setuptools \
        python3-wheel python3-cffi libcairo2 libpango-1.0-0 \
        libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev \
        shared-mime-info ttf-wqy-microhei ttf-wqy-zenhei socat \
        && pip install WeasyPrint \
        && pip install mkdocs mkdocs-pdf-export-plugin mkdocs-material \
        && pip install pygments pymdown-extensions \
        && mkdir ~/.fonts && cd ~/.fonts/ \
        && wget https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/MaterialIcons-Regular.ttf \
        && wget https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/MaterialIcons-Regular.woff \
        && wget https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/MaterialIcons-Regular.eot \
        
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_AMS-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_AMS-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_AMS-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Caligraphic-Bold.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Caligraphic-Bold.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Caligraphic-Bold.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Fraktur-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Fraktur-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Fraktur-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Fraktur-Bold.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Fraktur-Bold.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Fraktur-Bold.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Math-BoldItalic.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Math-BoldItalic.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Math-BoldItalic.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_SansSerif-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_SansSerif-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_SansSerif-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_SansSerif-Bold.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_SansSerif-Bold.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_SansSerif-Bold.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_SansSerif-Italic.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_SansSerif-Italic.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_SansSerif-Italic.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Script-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Script-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Script-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Typewriter-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Typewriter-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Typewriter-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Caligraphic-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Caligraphic-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Caligraphic-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Main-Bold.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Main-Bold.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Main-Bold.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Main-Italic.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Main-Italic.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Main-Italic.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Main-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Main-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Main-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Math-Italic.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Math-Italic.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Math-Italic.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Size1-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Size1-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Size1-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Size2-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Size2-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Size2-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Size3-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Size3-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Size3-Regular.otf \

        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/eot/MathJax_Size4-Regular.eot \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/woff/MathJax_Size4-Regular.woff \
        && wget https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/fonts/HTML-CSS/TeX/otf/MathJax_Size4-Regular.otf \

        && mkdir /data && rm -rf /var/lib/apt/lists/*

WORKDIR /data

EXPOSE 80

VOLUME ["/data"]

CMD ["python3"]
