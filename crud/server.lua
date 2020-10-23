local connection = nil

addEventHandler("onResourceStart", resourceRoot, function ()
    connection = dbConnect( "mysql", "dbname=ivanking; host=localhost", "root", "")
    if not connection then
        outputDebugString("Error MySQL")
    else
        outputDebugString("Success MySQL")
    end
end)

onUserCreated = function (name, surname, address)
    local q = dbQuery(connection, "INSERT INTO users (name, surname, address) VALUES (?, ?, ?)", name, surname, address)
    dbFree(q)

    triggerClientEvent(client, "startRefreshUsers", client)
end
addEvent("onUserCreated", true)
addEventHandler("onUserCreated", getRootElement(), onUserCreated)

onUserUpdated = function (ID, name, surname, address)
    local q = dbQuery(connection, "UPDATE users SET name = ?, surname = ?, address = ? WHERE ID = ?", name, surname, address, ID)
    dbFree(q)

    triggerClientEvent(client, "startRefreshUsers", client)
end
addEvent("onUserUpdated", true)
addEventHandler("onUserUpdated", getRootElement(), onUserUpdated)


getUsers = function ()
    dbQuery(getUsersCallback, {client}, connection, "SELECT * FROM users")
end
addEvent("getUsers", true)
addEventHandler("getUsers", getRootElement(), getUsers)


getUsersCallback = function (q, client)
    local users = dbPoll(q, 0)
    
    triggerClientEvent(client, "refreshUsersDatabase", client, users)
end    


deleteUser = function (ID)
    local q = dbQuery(connection, "DELETE FROM users WHERE ID = ?", tonumber(ID))
    dbFree(q)

    triggerClientEvent(client, "startRefreshUsers", client)
end
addEvent("deleteUser", true)
addEventHandler("deleteUser", getRootElement(), deleteUser)
