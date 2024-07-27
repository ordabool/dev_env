# Usage

Run 

```
docker build -t dev --rm . &&  docker run --name dev --rm -v "./nvim:/home/developer/.config/nvim" -v "/Users/ordabool/code:/code" -v "/Users/ordabool/.ssh:/home/developer/.ssh" -it dev
```

to build and run the container.
Also map a volume for the source code you want to work on.
