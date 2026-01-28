<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <title>Create Class</title>
</head>
<body>

<jsp:include page="../layout/header.jsp"/>

<h2>Create New Class</h2>

<form action="create-class" method="post">
    <label>Class Name:</label><br/>
    <input type="text" name="className" required /><br/><br/>

    <label>Description:</label><br/>
    <textarea name="description"></textarea><br/><br/>

    <button type="submit">Create</button>
</form>

</body>
</html>
