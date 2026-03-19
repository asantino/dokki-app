# ЭТАП 1: Сборка
FROM debian:latest AS build-env

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app
COPY . .

# Принимаем переменные из Railway для генерации env.g.dart
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY

# Создаем временный .env файл, чтобы генератор кода сработал
RUN echo "SUPABASE_URL=$SUPABASE_URL" > .env
RUN echo "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" >> .env

RUN flutter pub get

# Запускаем генерацию кода (создаем тот самый _Env)
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Теперь собираем веб
RUN flutter build web --release

# ЭТАП 2: Запуск
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
