
        </div>
    </div>
</div>

<!-- Logout Modal -->
<div class="modal-overlay" id="logoutModal">
    <div class="modal">
        <div class="modal-icon">&#9888;</div>
        <h3>Logout</h3>
        <p>Are you sure you want to logout?</p>
        <div class="btn-group" style="justify-content: center;">
            <button class="btn btn-secondary" onclick="closeLogoutModal()">Cancel</button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Yes, Logout</a>
        </div>
    </div>
</div>

<script>
function openLogoutModal() {
    document.getElementById('logoutModal').classList.add('show');
}
function closeLogoutModal() {
    document.getElementById('logoutModal').classList.remove('show');
}
</script>
</body>
</html>
