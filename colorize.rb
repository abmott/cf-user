def colorize(text, color_code)
  "#{color_code}#{text}\x1B[0m"
end

def red(text); colorize(text, "\x1B[31m"); end
def green(text); colorize(text, "\x1B[32m"); end
def yellow(text); colorize(text, "\x1B[33m"); end
def blue(text); colorize(text, "\x1B[34m"); end
def white(text); colorize(text, "\x1B[37m"); end
