vim9script

import autoload "bekken.vim" as b

export def FilterKey(): string
  return "name"
enddef

export def ListAsync(Cb: func(list<dict<any>>): bool, ...args: list<any>): void
  denops#request_async(
    "bekken-launcher", "list", [args],
    (launchers: list<dict<any>>) => Cb(launchers->copy()->map((key, launcher) => launcher.items)->flattennew()),
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
      if selected->has_key("silent") && selected.silent == true
        silent execute selected.command
      else
        execute selected.command
      endif
    endif
  endif

  return true
enddef
