vim9script

import autoload "bekken.vim" as b

export def FilterKey(): string
  return "title"
enddef

export def ListAsync(Cb: func(list<dict<any>>): bool, ...args: list<any>): void
  denops#request_async(
    "bekken-launcher", "list", [args],
    (launchers: list<dict<any>>) => Cb(launchers->copy()->map((key, launcher) => ({ title: launcher.title, path: launcher.path }))),
    (err: any) => {
      echoerr err
      return Cb([])
    },
  )
enddef

export def Filter(key: string, bekken: b.Bekken): bool
  if "\<Cr>" == key
    const selected = bekken.GetResource().selected
    bekken.Close()

    if selected != null
      call bekken#Open("launcher", [selected.path], {})
    endif
  endif

  return true
enddef

