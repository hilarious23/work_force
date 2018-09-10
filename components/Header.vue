<template>
    <header class="header">
        <ul class="nav-items">
            <li class="home-botton">
                <nuxt-link to="/">Home</nuxt-link>
            </li>
        </ul>
    </header>
</template>

<style scoped>
    .header {
        width: 100%;
        height: 60px;
        display: flex;
        justify-content: center;
        align-items: center;
        position: fixed;
        left: 0px;
        right: 0px;
        top: 0px;
    }
    .nav-items {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        justify-content: space-around;
        align-items: center;
        width: 80%; 
        background-color: rgb(65, 209, 245);
    }
    .nav-items a {
        text-decoration: none;
        color: black;
    }
    .nav-items a:hover,
    .nav-items a:active {
        color: white;
    }
</style>