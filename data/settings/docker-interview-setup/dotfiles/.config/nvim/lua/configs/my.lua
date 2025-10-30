local open_entity= function()
    local current_file = vim.fn.expand('%:t')
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub('\n', '')

    local search_path = git_root .. "/entity/"

    local similar_file_path = search_path .. current_file

    if vim.fn.filereadable(similar_file_path) == 1 then
        vim.cmd('vsplit ' .. similar_file_path)
    else
        print("파일을 찾을 수 없습니다: " .. similar_file_path)
    end
end

