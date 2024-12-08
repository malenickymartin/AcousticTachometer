function i = argmax(x)
    % Are you serious? Matlab doesn't have standalone argmax function?
        % Input:
        %     x: array of numbers
        % Output:
        %     i: Index of the maximum value in the array
        
        [~, i] = max(x, [], 1);
    end