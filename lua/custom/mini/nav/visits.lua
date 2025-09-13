local M = function()
  -- MiniVisits setup (clean)
  local visits = require 'mini.visits'
  visits.setup {
    silent = false,
    list = {
      filter = function(d)
        local p = d.path
        return not p:match '/node_modules/' and not p:match '/%.git/'
      end,
      sort = visits.gen_sort.default { recency_weight = 0.6 },
    },
    store = {
      autowrite = true,
      normalize = visits.gen_normalize.default {
        decay_threshold = 800,
        decay_target = 600,
        prune_threshold = 0.75,
      },
      path = vim.fn.stdpath 'data' .. '/mini-visits-index',
    },
    track = { event = 'BufEnter', delay = 700 },
  }

  vim.api.nvim_create_user_command('VisitsWrite', function()
    visits.write_index()
    vim.notify('MiniVisits: index written', vim.log.levels.INFO)
  end, {})

  local function select_paths_with_label(label)
    if not label then
      return
    end
    visits.select_path('', {
      filter = function(d)
        return d.labels and d.labels[label]
      end,
    })
  end

  local function show_current_label_paths()
    local path = vim.api.nvim_buf_get_name(0)
    if path == '' then
      return
    end
    local cwd = vim.loop.cwd()
    local index = visits.get_index()
    local cwd_tbl = index[cwd]
    local entry = cwd_tbl and cwd_tbl[path]
    if not entry or not entry.labels then
      vim.notify('No labels on current file', vim.log.levels.INFO)
      return
    end
    local labels = {}
    for l, _ in pairs(entry.labels) do
      table.insert(labels, l)
    end
    table.sort(labels)
    if #labels == 1 then
      select_paths_with_label(labels[1])
    else
      vim.ui.select(labels, { prompt = 'Label:' }, function(choice)
        select_paths_with_label(choice)
      end)
    end
  end

  if not vim.g.__minivisits_keys then
    local map = vim.keymap.set
    local function sel(global, w)
      local sort = visits.gen_sort.default { recency_weight = w }
      return function()
        local cwd = global and '' or vim.fn.getcwd()
        visits.select_path(cwd, { sort = sort })
      end
    end

    -- Helper: pick label to remove (global vs cwd-scoped)
    local function pick_label(remove_cwd_scoped)
      local path = vim.api.nvim_buf_get_name(0)
      if path == '' then
        vim.notify('No file path', vim.log.levels.INFO)
        return
      end
      local index = visits.get_index()
      local labels_set = {}

      if remove_cwd_scoped then
        -- Only labels from current cwd
        local cwd = vim.loop.cwd()
        local entry = index[cwd] and index[cwd][path]
        if not entry or not entry.labels then
          vim.notify('No labels on current file (cwd)', vim.log.levels.INFO)
          return
        end
        for l, _ in pairs(entry.labels) do
          labels_set[l] = true
        end
      else
        -- Union of labels for this path across ALL cwd
        for _, cwd_tbl in pairs(index) do
          local entry = cwd_tbl[path]
          if entry and entry.labels then
            for l, _ in pairs(entry.labels) do
              labels_set[l] = true
            end
          end
        end
        if next(labels_set) == nil then
          vim.notify('No labels on current file (global)', vim.log.levels.INFO)
          return
        end
      end

      local labels = {}
      for l, _ in pairs(labels_set) do
        table.insert(labels, l)
      end
      table.sort(labels)

      vim.ui.select(labels, { prompt = 'Remove label:' }, function(choice)
        if not choice then
          return
        end
        if remove_cwd_scoped then
          visits.remove_label(choice, path, vim.fn.getcwd())
        else
          -- '' = all cwd (global)
          visits.remove_label(choice, path, '')
        end
      end)
    end

    -- Sorting variants
    map('n', '<leader>vr', sel(true, 1), { desc = 'Visits recent (all)' })
    map('n', '<leader>vR', sel(false, 1), { desc = 'Visits recent (cwd)' })
    map('n', '<leader>vy', sel(true, 0.5), { desc = 'Visits frecent (all)' })
    map('n', '<leader>vY', sel(false, 0.5), { desc = 'Visits frecent (cwd)' })
    map('n', '<leader>vf', sel(true, 0), { desc = 'Visits frequent (all)' })
    map('n', '<leader>vF', sel(false, 0), { desc = 'Visits frequent (cwd)' })

    -- Labels (buffer)
    map('n', '<leader>va', function()
      visits.add_label()
    end, { desc = 'Visit add label (buffer)' })
    map('n', '<leader>vA', function()
      pick_label(false)
    end, { desc = 'Visit remove label (buffer, global)' })

    -- Labels (cwd scoped add/remove)
    map('n', '<leader>vda', function()
      visits.add_label(nil, nil, vim.fn.getcwd())
    end, { desc = 'Visit add label (cwd scoped)' })
    map('n', '<leader>vdA', function()
      pick_label(true)
    end, { desc = 'Visit remove label (cwd scoped)' })

    -- Select labels
    map('n', '<leader>vl', function()
      visits.select_label('', '')
    end, { desc = 'Visit select label (all)' })
    map('n', '<leader>vL', function()
      visits.select_label()
    end, { desc = 'Visit select label (cwd)' })

    -- Select only labeled paths (global)
    map('n', '<leader>vP', function()
      visits.select_path('', {
        filter = function(d)
          return d.labels and next(d.labels) ~= nil
        end,
      })
    end, { desc = 'Visit select labeled (all)' })

    -- Show files sharing current file labels
    map('n', '<leader>vp', show_current_label_paths, { desc = 'Visit paths in current labels' })

    -- Iterate by recency within cwd
    local sort_latest = visits.gen_sort.default { recency_weight = 1 }
    local function iter(dir)
      visits.iterate_paths(dir, vim.fn.getcwd(), { sort = sort_latest, wrap = true })
    end
    map('n', '[v', function()
      iter 'forward'
    end, { desc = 'Visits earlier' })
    map('n', ']v', function()
      iter 'backward'
    end, { desc = 'Visits later' })

    -- Fixed "core" label
    map('n', '<leader>vc', function()
      visits.add_label 'core'
    end, { desc = 'Visit add core' })
    map('n', '<leader>vC', function()
      visits.remove_label 'core'
    end, { desc = 'Visit remove core' })
    map('n', '<leader>v*', function()
      visits.select_path(nil, {
        filter = function(d)
          return d.labels and d.labels.core
        end,
        sort = sort_latest,
      })
    end, { desc = 'Visit select core (cwd)' })

    vim.g.__minivisits_keys = true
  end
end
return M
